# frozen_string_literal: true

class Configuration
  include Singleton

  def init
    # initiate storage
    Storages::Base.instance.init
  end
end
