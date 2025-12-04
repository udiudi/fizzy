module Card::Pinnable
  extend ActiveSupport::Concern

  included do
    has_many :pins, dependent: :destroy

    after_update_commit :broadcast_pin_updates
  end

  def broadcast_pin_updates
    pins.each do |pin|
      pin.broadcast_replace_to [ pin.user, :pins_tray ], partial: "my/pins/pin"
    end
  end

  def pinned_by?(user)
    pins.exists?(user: user)
  end

  def pin_for(user)
    pins.find_by(user: user)
  end

  def pin_by(user)
    pins.find_or_create_by!(user: user)
  end

  def unpin_by(user)
    pins.find_by(user: user).tap { it.destroy }
  end
end
