class WorkHistory < ActiveRecord::Base
  validates :company, :mentor_id, :date_started, :title, presence: true
  belongs_to :mentor

  after_create :rebuild_pg_search_documents
  after_update :rebuild_pg_search_documents, :if => :company_changed?

  def rebuild_pg_search_documents
    self.mentor.update_pg_search_document
  end
end
