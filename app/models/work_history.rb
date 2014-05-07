class WorkHistory < ActiveRecord::Base
  validates :company, :mentor_id, :date_started, :title, presence: true
  belongs_to :mentor

  default_scope { order('current_work DESC, id DESC') }

  after_create :rebuild_pg_search_documents
  after_update :rebuild_pg_search_documents, :if => :company_changed?

  def rebuild_pg_search_documents
    self.mentor.update_pg_search_document
  end

  def started_month
    self.date_started.split(" ")[0]
  end

  def started_year
    self.date_started.split(" ")[1]
  end

  def ended_month
    self.date_ended.split(" ")[0] if self.date_ended
  end

  def ended_year
    self.date_ended.split(" ")[1] if self.date_ended
  end
end
