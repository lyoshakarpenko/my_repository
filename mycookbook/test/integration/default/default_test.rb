# # encoding: utf-8

# Inspec test for recipe mycookbook::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

#unless os.windows?

describe docker.containers do
    its('images') { should include 'registry:2' }
end

describe docker.version do
    its('Server.Version') { should cmp >= '18.0'}
    its('Client.Version') { should cmp >= '18.0'}
end

describe port(5000) do
    it { should be_listening }
end