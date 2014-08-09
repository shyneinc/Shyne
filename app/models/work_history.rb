class WorkHistory < ActiveRecord::Base
  validates :company, :advisor_id, :date_started, :title, presence: true
  belongs_to :advisor

  default_scope { order("current_work DESC, to_date(date_started, 'Month YYYY') DESC, id DESC") }

  after_create :rebuild_pg_search_documents
  after_update :rebuild_pg_search_documents, :if => :company_changed?

  def rebuild_pg_search_documents
    self.advisor.update_pg_search_document
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
