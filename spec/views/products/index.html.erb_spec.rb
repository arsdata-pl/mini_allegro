require 'rails_helper'

RSpec.describe "products/index.html.erb", type: :view do
  describe 'index' do
    let(:manufacturer) { create(:manufacturer) }
    let!(:product) { create(:product, name: 'Acme', manufacturer: manufacturer) }

    before(:each) do
      assign(:products, Product.page(1))
      assign(:categories, [AggregationPresenter.new({'key' => 'Cat1', 'doc_count' => 1})])
      assign(:manufacturers, [AggregationPresenter.new({'key' => 'Man1', 'doc_count' => 1})])
    end

    it 'displays all the products ' do
      render

      expect(rendered).to match /Acme/
    end

    it 'displays categories' do
      render

      expect(rendered).to match(/Cat1 \(1\)/)
    end

    it 'displays manufacturers' do
      render

      expect(rendered).to match(/Man1 \(1\)/)
    end
  end
end
