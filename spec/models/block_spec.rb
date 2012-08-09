require 'spec_helper'

describe Block do
  it { should belong_to(:user) }
  it { should belong_to(:receiver) }
end
