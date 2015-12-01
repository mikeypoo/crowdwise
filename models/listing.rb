class Listing
  include DataMapper::Resource

  STATUSES = {
    active: 'active',
    deleted: 'deleted'
  }

  property :id, Serial
  property :name, String
  property :status, String, default: STATUSES[:active]

  def activate!
    return if self.activated?
    self.status = STATUSES[:active]
    self.save
  end

  def delete!
    return if self.deleted?
    self.status = STATUSES[:deleted]
    self.save
  end

  def deleted?
    self.status == STATUSES[:deleted]
  end

  def activated?
    self.status == STATUSES[:active]
  end
end
