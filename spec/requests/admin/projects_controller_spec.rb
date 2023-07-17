RSpec.describe Admin::ProjectsController, type: :request do
  before do
    allow_any_instance_of(Admin::HomeController).to receive(:require_login).and_return(nil)
  end

  describe '#update' do
    let!(:project) { create(:project) }

    context 'when params valid' do
      let(:params) { attributes_for(:project) }

      it 'is update project shortlink' do
        expect do
          put "/admin/projects/#{project.id}", params: { project: params }
        end.to(change { Project.first.shortlink })
      end

      it 'is update project title' do
        expect do
          put "/admin/projects/#{project.id}", params: { project: params }
        end.to(change { Project.first.title })
      end

      it 'is update project content' do
        expect do
          put "/admin/projects/#{project.id}", params: { project: params }
        end.to(change { Project.first.content })
      end

      it 'is update project keywords' do
        expect do
          put "/admin/projects/#{project.id}", params: { project: params }
        end.to(change { Project.first.keywords })
      end

      it 'is update project description' do
        expect do
          put "/admin/projects/#{project.id}", params: { project: params }
        end.to(change { Project.first.description })
      end
    end

    context 'when invalid params' do
      it 'is not update project title' do
        expect do
          put "/admin/projects/#{project.id}", params: { project: { title: '' } }
        end.not_to(change { Project.first.title })
      end
    end
  end

  describe '#update position' do
    let!(:project) { create(:project, position: 1) }
    let!(:second_project) { create(:project, position: 0) }

    context 'when admin update project position' do
      let(:params) { { project_id: project.id, row_position: second_project.position } }

      it 'is update project position' do
        expect do
          put '/admin/projects/update_position', params: { project: params }
        end.to(change { Project.first.position })
      end
    end
  end

  describe '#sort project screenshots' do
    let!(:screenshot) { create(:screenshot, position: 1) }

    context 'when admin run sort project screenshots function' do
      let(:params) { { screenshot_id: screenshot.id, row_position: 0 } }

      it 'is sort project screenshots' do
        expect do
          put "/admin/projects/#{screenshot.project.id}/sort_project_screenshots", params: { project: params }
        end.to(change { Screenshot.first.position })
      end
    end
  end

  # describe '#sort project technologies' do
  #   let(:technology) { create(:technology, position: 1) }
  #   let!(:technologies_project) { create(:technologies_project, position: 0, technology:) }

  #   context 'when admin run sort technologies' do
  #     let(:params) do
  #       { project_technology_id: technologies_project.technology.id,
  #         row_tech_position: technology.position.next }
  #     end

  #     it 'is sort project technologies' do
  #       expect do
  #         put "/admin/projects/#{technologies_project.project.id}/sort_project_technologies",
  #             params: { project: params }
  #       end.to(change { TechnologiesProject.first.position })
  #     end
  #   end
  # end
end
