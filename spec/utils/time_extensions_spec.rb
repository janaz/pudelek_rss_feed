require 'spec_helper'

describe Time do
  subject {Time.at(1234567899).utc}
  its(:to_rfc3339) { should == '2009-02-13T23:31:39+00:00'}
end