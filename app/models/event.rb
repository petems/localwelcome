class Event < ActiveRecord::Base
  belongs_to :chapter
  has_many :invitations
  has_many :users, through: :invitations

  validates :chapter, presence: true
  validates :title, presence: true
  validates :starts_at, presence: true
  validates :ends_at, presence: true
  validate :starts_before_it_ends

  scope :chronological, -> { order({starts_at: :asc}) }
  scope :archaeological, -> { order({starts_at: :desc}) }
  scope :published, -> { where(published: true) }
  scope :unpublished, -> { where(published: false) }

  def in_the_past?
    ends_at < Time.zone.now
  end


  protected

  def starts_before_it_ends
    if ends_at && starts_at && ends_at <= starts_at
      errors.add(:ends_at, "Event must end after the start time.")
    end
  end
end
