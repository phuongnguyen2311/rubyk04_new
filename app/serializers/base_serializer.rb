class BaseSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  include ActionView::Helpers::DateHelper
end