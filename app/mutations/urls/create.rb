class Urls::Create < ApplicationMutation
  required do
    model :user, class: User
    string :title
    string :original_url
  end

  protected

  def execute
    Url.new(inputs)
  end

  def validate
  end
end
