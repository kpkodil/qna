shared_examples_for "API Postable" do
  context 'authorized' do
    context 'with valid attributes' do
  
      it 'returns 200 status' do
        post_resource(resource, body, links, title)
        expect(response).to be_successful
      end    

      it 'saves a new resource in the database' do
        expect { post_resource(resource, body, links, title) }.to change(resource.class, :count).by(1)
      end
    end
    
    context 'with invalid attributes' do
        
      it 'returns 400 status' do
        post_resource(resource, body="", links, title)
        expect(response.status).to eq 400
      end       

      it 'do not save a new resource in the database' do
        expect { post_resource(resource, body="", links, title) }.to_not change(resource.class, :count)
      end
    end
  end
end

def post_resource(resource, body, links, title)
  if resource.class == "Question".constantize
    post api_path, params: { access_token: access_token.token, question: { title: title, body: body, links: links } }, headers: headers
  elsif resource.class == "Answer".constantize
    post api_path, params: { access_token: access_token.token, answer: { body: body, links: links } }, headers: headers
  end  
end
