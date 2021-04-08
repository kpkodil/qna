shared_examples_for "Attachable" do
  it 'have many attached files' do
    expect(resource_class.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end