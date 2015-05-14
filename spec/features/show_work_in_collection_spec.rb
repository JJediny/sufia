require 'spec_helper'

describe "In Show Collection", :type => :feature do
  let(:user) { create :jill }

  let!(:work) {
    GenericWork.new.tap do |work|
      work.title = ['work title abc']
      work.apply_depositor_metadata(user.user_key)
      work.read_groups = ['public']
      work.save!
    end
  }

  let!(:collection) {
    Collection.new.tap do |f|
      f.title = 'collection title abc'
      f.apply_depositor_metadata(user.user_key)
      f.read_groups = ['public']
      f.members = [work]
      f.save
    end
  }

  before { sign_in user }

  context "when signed in" do

    before do
      sign_in user
    end

    it 'should redirect to show work page when clicking on work thumbnail' do
      visit "collections/#{collection.id}"
      within(".media") do
        expect(page).to have_css("span.glyphicon")
        expect(page).to have_css("span.glyphicon-th")
        first('.media-left').click
      end
      # TODO: replace with real work show page
      expect(page).to have_content "todo show page"
    end

    it 'should redirect to show work page when clicking on work title' do
      visit "collections/#{collection.id}"
      click_link "src_copy_link#{work.id}"
      # TODO: replace with real work show page
      expect(page).to have_content "todo show page"
    end

  end
end
