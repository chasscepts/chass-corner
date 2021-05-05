# This code is copied verbatim from link below
# https://spin.atomicobject.com/2017/07/07/rails-n1-queries-rspec-matcher/

RSpec::Matchers.define :not_talk_to_db do |_expected|
  match do |block_to_test|
    %w(exec_delete exec_insert exec_query exec_update).each do |meth|
      expect(ActiveRecord::Base.connection).not_to receive(meth)
    end
    block_to_test.call
  end
  supports_block_expectations
end

RSpec::Matchers.define :query_db do |expected|
  match do |block_to_test|
    %w(exec_delete exec_insert exec_query exec_update).each do |meth|
      # logger.should_receive(:account_opened).exactly(3).times
      expect(ActiveRecord::Base.connection).to receive(meth).exactly(expected).times
    end
    block_to_test.call
  end
  supports_block_expectations
end
