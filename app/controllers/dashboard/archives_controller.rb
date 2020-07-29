class Dashboard::ArchivesController < DashboardController
  before_action :set_archive

  def show
    send_file @archive.archive.path.sub(/releases\/\d{14}/, 'current'),
      filename: "#{File.basename(@archive.archive.url)}",
      type: 'application/pdf'
  end

  private

    def set_archive
      @archive = Archive.find params[:id]
    end
end
