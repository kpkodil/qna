shared_examples_for "API Deleteable" do
  context 'authorized' do
    context "User is an author of the resource" do

      it 'returns 200 status' do
        delete api_path, params: { access_token: access_token.token }, headers: headers
        expect(response).to be_successful
      end   

      it "delete the resource from the database" do
        expect{ delete api_path, params: { access_token: access_token.token }, headers: headers }.to change(resource.class, :count).by(-1)
      end
    end

    context "User is not an author of the resource" do
      let!(:other) { create(:user) }
      let!(:access_token) { create(:access_token, resource_owner_id: other.id) }

      it 'returns 403 status' do
        delete api_path, params: { access_token: access_token.token }, headers: headers
        expect(response.status).to eq 403
      end  

      it "does not delete the resource from the database" do
        expect { delete api_path, params: { access_token: access_token.token }, headers: headers }.to_not change(resource.class, :count)
      end
    end
  end
end