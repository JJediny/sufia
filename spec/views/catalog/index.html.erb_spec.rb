describe 'catalog/index.html.erb', type: :view do
  let(:collection) { build(:collection, id: "abc123") }
  let(:doc) { SolrDocument.new(collection.to_solr) }
  let(:search_state) { double('SearchState', to_h: {}) }
  let(:blacklight_configuration_context) do
    Blacklight::Configuration::Context.new(controller)
  end

  before do
    view.extend CurationConcerns::CollectionsHelper
    allow(view).to receive(:current_users_collections).and_return([])
    allow(view).to receive(:blacklight_config).and_return(CatalogController.blacklight_config)
    allow(view).to receive(:blacklight_configuration_context).and_return(blacklight_configuration_context)
    stub_template 'catalog/_search_sidebar.html.erb' => ''
    stub_template 'catalog/_search_header.html.erb' => ''
    allow(view).to receive(:render_opensearch_response_metadata).and_return('')
    allow(view).to receive(:render_grouped_response?).and_return(false)
    allow(view).to receive(:search_session).and_return({})
    allow(view).to receive(:current_search_session).and_return(nil)
    allow(view).to receive(:document_counter_with_offset).and_return(5)
    allow(view).to receive(:type_tab).and_return("TYPE")
    allow(view).to receive(:search_state).and_return(search_state)
    allow(controller).to receive(:render_bookmarks_control?).and_return(false)

    params[:view] = 'gallery'

    resp = []
    assign(:response, resp)
    allow(resp).to receive(:total_pages).and_return(1)
    allow(resp).to receive(:current_page).and_return(1)
    allow(resp).to receive(:limit_value).and_return(10)
    allow(resp).to receive(:empty?).and_return(false)

    assign(:document_list, [doc])
  end

  context "when user does not have permissions" do
    before { allow(view).to receive(:can?).and_return(false) }
    it 'appears on page without error' do
      render
      expect(rendered).to include(collection.title.first)
      page = Capybara::Node::Simple.new(rendered)
      expect(page).to have_selector("span.fa.fa-cubes.collection-icon-search")
    end
  end
  context "when user has all the permissions" do
    before { allow(view).to receive(:can?).and_return(true) }
    it 'appears on page without error' do
      render
      expect(rendered).to include(collection.title.first)
      page = Capybara::Node::Simple.new(rendered)
      expect(page).to have_selector("span.fa.fa-cubes.collection-icon-search")
    end
  end
end
