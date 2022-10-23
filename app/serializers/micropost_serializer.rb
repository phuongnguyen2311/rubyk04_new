class MicropostSerializer < BaseSerializer
  attributes :id, :content, :image, :time_to_post

  def image
    image = object.image.variant(resize_to_limit: [200, 200])
    rails_representation_url(image) if object.image.attached?
  end

  def time_to_post
    "Posted #{time_ago_in_words object.created_at} ago."
  end
end
