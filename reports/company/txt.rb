
module Reports
  module Company
    class Txt
      def initialize(company)
        @company = company
        @total = @company.users.sum { |user| user.active_status ? (@company.top_up + user.tokens) - user.tokens : 0 }
      end

      def assemble
        return "\n\n" if @total.zero?

        "\tCompany Id: #{@company.id}\n"\
        "\tCompany Name: #{@company.name}\n"\
        "\t#{user_emailed_line}"\
        "\t#{user_not_emailed_line}"\
        "#{total_top_up_line}\n\n"\
      end

      def user_line(user)
        "\t\t#{user.last_name}, #{user.first_name}, #{user.email}\n"
      end

      def tokens_lines(user)
        new_token = @company.top_up + user.tokens if user.active_status
        new_token ? "\t\t  Previous Token Balance, #{user.tokens}\n\t\t  New Token Balance #{new_token}\n" : ""
      end

      def user_emailed_line
        line = "Users Emailed:\n"
        @company.active_emailed_users.sort_by(&:last_name).each do |user|
          line << user_line(user)
          line << tokens_lines(user)
        end
        line
      end

      def user_not_emailed_line
        line = "Users Not Emailed:\n"
        @company.active_not_emailed_users.sort_by(&:last_name).each do |user|
          line << user_line(user)
          line << tokens_lines(user)
        end
        line
      end

      def total_top_up_line
        "\t\tTotal amount of top ups for #{@company.name}: #{@total}"
      end
    end
  end
end

