module ApplicationHelper
  def format_currency(number)
    formated_number = ActionController::Base.helpers.number_to_currency(number, unit: '', separator: ',', delimiter: '.')
    "R$ #{formated_number}"
  end
end
