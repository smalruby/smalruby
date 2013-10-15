# -*- coding: utf-8 -*-
require 'spec_helper'

describe Smalruby::World do
  describe '.instance' do
    subject { described_class.instance }

    it { should be_kind_of(described_class) }

    it '何度呼び出しても同じインスタンスを返す' do
      should be(described_class.instance)
    end
  end
end
