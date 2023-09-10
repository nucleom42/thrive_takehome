# frozen_string_literal: true

require './configuration'

# run config
Configuration.instance.init

RSpec.describe Reports::Company::Txt do
  let!(:company) do
    company = Models::Company.new(id: 1, name: "Blue Cat Inc.", top_up: 10, email_status: false)
    company.save
    Models::Company.find(1)
  end
  let!(:user1) do
    user1 = Models::User.new(id: 19, first_name: "Eileen", last_name: "Lynch", email: "aaa@fake.com",
                     company_id: 1, email_status: true, active_status: true, tokens: 10)
    user1.save
    Models::User.find(19)
  end
  let!(:user2) do
    user2 = Models::User.new(id: 20, first_name: "Goblin", last_name: "Poo", email: "bbb@fake.com",
                     company_id: 1, email_status: false, active_status: true, tokens: 15)
    user2.save
    Models::User.find(20)
  end
  let!(:user3) do
    user3 = Models::User.new(id: 21, first_name: "Shneider", last_name: "Zion", email: "ggg@fake.com",
                     company_id: 1, email_status: true, active_status: false, tokens: 5)
    user3.save
    Models::User.find(21)
  end

  describe '#assemble' do
    it 'returns an empty string if total is zero' do
      allow(company.users).to receive(:sum).and_return(0)

      txt_report = Reports::Company::Txt.new(company)
      expect(txt_report.assemble).to eq("\n\n")
    end

    it 'includes Company Id line' do
      txt_report = Reports::Company::Txt.new(company)

      expect(txt_report.assemble).to include("Company Id: 1")
    end

    it 'includes Company Name:' do
      txt_report = Reports::Company::Txt.new(company)

      expect(txt_report.assemble).to include("Company Name: #{company.name}")
    end

    it 'includes users1 line under Users Emailed' do
      txt_report = Reports::Company::Txt.new(company)

      expect(txt_report.assemble)
        .to include("Users Emailed:\n\t\t#{user1.last_name}, #{user1.first_name}, #{user1.email}")
    end

    it 'includes users2 line under Users Not Emailed' do
      txt_report = Reports::Company::Txt.new(company)

      expect(txt_report.assemble)
        .to include("Users Not Emailed:\n\t\t#{user2.last_name}, #{user2.first_name}, #{user2.email}")
    end

    it 'not include users3 line' do
      txt_report = Reports::Company::Txt.new(company)

      expect(txt_report.assemble).not_to include("#{user3.last_name}, #{user3.first_name}, #{user3.email}")
    end

    it 'includes users1 tokens balances' do
      txt_report = Reports::Company::Txt.new(company)

      expect(txt_report.assemble)
        .to include(
          "Previous Token Balance, #{user1.tokens}\n\t\t  New Token Balance #{user1.tokens + company.top_up}"
        )
    end

    it 'includes users2 tokens balances' do
      txt_report = Reports::Company::Txt.new(company)

      expect(txt_report.assemble)
        .to include(
          "Previous Token Balance, #{user2.tokens}\n\t\t  New Token Balance #{user2.tokens + company.top_up}"
        )
    end

    it 'includes total ups line' do
      txt_report = Reports::Company::Txt.new(company)
      total = company.users.sum { |user| user.active_status ? (company.top_up + user.tokens) - user.tokens : 0 }

      expect(txt_report.assemble)
        .to include("Total amount of top ups for #{company.name}: #{total}")
    end
  end
end
