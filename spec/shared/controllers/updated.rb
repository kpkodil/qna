shared_examples_for "Updated" do
  before { login(author) }
  let(:resource_symbol) { resource.class.to_s.underscore.to_sym }
  
  context 'with valid attributes' do


    it 'assigns the requested resource to @resource' do
      valid_update_resource(resource, new_body, new_title)
      expect(assigns(resource_symbol)).to eq resource
    end

    it 'changes resource attributes' do
      valid_update_resource(resource, new_body, new_title)
      resource.reload
      expect(resource.body).to eq new_body
    end

    it 'renders update view' do
      valid_update_resource(resource, new_body, new_title)
      expect(response).to render_template :update
    end
  end

  context 'with invalid attributes' do

    it 'does not change resource attributes' do
      expect { invalid_update_resource(resource) }.to_not change(resource, :body)
    end

    it 'renders update view' do
      invalid_update_resource(resource)
      expect(response).to render_template :update
    end
  end
end

def valid_update_resource(resource, new_body, new_title)
  if resource.class == "Question".constantize
    patch :update, params: { id: resource, question: { title: new_title, body: new_body } }, format: :js
  elsif resource.class == "Answer".constantize
    patch :update, params: { id: resource, answer: { body: new_body } }, format: :js
  end  
end

def invalid_update_resource(resource)
  if resource.class == "Question".constantize
    patch :update, params: { id: resource, question: attributes_for(resource_symbol, :invalid) }, format: :js
  elsif resource.class == "Answer".constantize
    patch :update, params: { id: resource, answer: attributes_for(resource_symbol, :invalid) }, format: :js
  end  
end