RSpec.describe Admin::ProjectsController, type: :request do
  before do
    allow_any_instance_of(Admin::HomeController).to receive(:require_login).and_return(nil)
    allow_any_instance_of(ApplicationController).to receive(:geoip_lang).and_return('en')
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
          put "/admin/projects/#{project.id}", params: { project: { title: nil } }
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
    let!(:screenshot) { create(:screenshot, position: 5) }

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
  describe '#sort project technologies' do
    it 'sorts project technologies' do
      project = create(:project)
      technology = I18n.with_locale(:en) { create(:technology, position: 0) }
      second_technology = I18n.with_locale(:en) { create(:technology, position: 1) }
      technologies_project = create(:technologies_project, project:, position: 0, technology:)
      second_technologies_project = create(:technologies_project, project:, position: 1, technology: second_technology)

      params = {
        project_technology_id: technologies_project.technology.id,
        row_tech_position: second_technologies_project.position
      }

      expect do
        put "/admin/projects/#{project.id}/sort_project_technologies",
            params: { project: params }, as: :json
      end.to(change { technologies_project.reload.position }.from(0))

      expect(technologies_project.reload.position).not_to eq(0)
    end
  end
end
