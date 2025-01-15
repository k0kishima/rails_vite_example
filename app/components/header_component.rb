# frozen_string_literal: true

class HeaderComponent < ViewComponent::Base
  def initialize(title:)
    @title = title
  end
end
