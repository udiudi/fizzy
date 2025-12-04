module User::Avatar
  extend ActiveSupport::Concern

  included do
    has_one_attached :avatar do |attachable|
      attachable.variant :thumb, resize_to_fill: [ 256, 256 ]
    end
  end

  def avatar_thumbnail
    avatar.variable? ? avatar.variant(:thumb) : avatar
  end
end
