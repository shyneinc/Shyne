require 'spec_helper'

describe WorkHistory do
  it "has a valid factory" do
    expect(build(:work_history)).to be_valid
  end

  let(:work_history) { create(:work_history) }

  describe "ActiveModel validations" do
    context "Basic validations" do
      it { should validate_presence_of :company }
      it { should validate_presence_of :year_started }
      it { should validate_presence_of :mentor_id }
      it { should validate_presence_of :title }
    end
  end

  describe "ActiveRecord validations" do
    context "Callbacks" do
      it { expect(work_history).to callback(:rebuild_pg_search_documents).after(:create) }
    end
  end
end
