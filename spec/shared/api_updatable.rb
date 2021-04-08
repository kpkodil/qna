shared_examples_for "API Updatable" do
  context 'authorized' do

    context 'with valid attributes' do

      it 'returns 200 status' do
        update_resource(resource, new_body, new_links, new_title)
        expect(response).to be_successful
      end   

      it 'changes resource attributes' do
        update_resource(resource, new_body, new_links, new_title)
        resource.reload
        expect(resource.body).to eq new_body
      end
    end

    context 'with invalid attributes' do

      it 'returns 400 status' do
        update_resource(resource, new_body="", new_links, new_title)
        expect(response.status).to eq 400
      end  

      it 'does not change resource attributes' do
        expect { update_resource(resource, new_body="", new_links, new_title) }.to_not change(resource, :body)
      end
    end
  end
end

def update_resource(resource, new_body, new_links, new_title)
  if resource.class == "Question".constantize
    patch api_path, params: { access_token: access_token.token, question: { title: new_title, body: new_body,links: new_links } }, headers: headers 
  elsif resource.class == "Answer".constantize
    patch api_path, params: { access_token: access_token.token, answer: { body: new_body,links: new_links } }, headers: headers 
  end  
end