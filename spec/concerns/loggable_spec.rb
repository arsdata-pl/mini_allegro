require 'rails_helper'

RSpec.describe Loggable do
  describe '#log' do
    let (:test_class) { Struct.new(:foo) { include Loggable } }
    let (:loggable) { test_class.new("Foo").log }

    it { expect(loggable).not_to be_nil }
    it { expect(loggable).to be_instance_of(Logger) }
  end
end
