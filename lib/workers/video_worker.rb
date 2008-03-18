class VideoWorker < BackgrounDRb::MetaWorker
  set_worker_name :video_worker

  def convert(id)
    @logger.info('Video conversion started')
    begin
      video_file = VideoFile.find(id)
      video_file.convert
    rescue ActiveRecord::RecordNotFound
      @logger.error("VideoFile with id #{id} not found ?!?")
    rescue => e
      @logger.error("Unknown Error in VideoWorker: #{e}")
    end
    @logger.info('Video conversion finished')
  end
  
end

