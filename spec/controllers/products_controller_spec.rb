require 'rails_helper'

RSpec.describe ProductsController, type: :controller do

  describe 'GET #index' do
    before(:each) { Product.reindex }

    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #search' do
    before { get :search }

    it { expect(response).to have_http_status(:success) }

    it { expect(response).to render_template(:index) }

    context 'when found product' do
      let!(:product) { create(:product, name: 'Foo') }
      before do
        Product.reindex
        get :search, params: { query: product.name }
      end

      it { expect(response).to have_http_status(:success) }

      it { expect(assigns(:products)).to include(product) }
    end

    context 'when product not found' do
      let!(:product) { create(:product, name: 'Foo') }
      before do
        Product.reindex
        get :search, params: { query: 'Bar' }
      end

      it { expect(response).to have_http_status(:success) }

      it { expect(assigns(:products)).not_to include(product) }
    end
  end

end
