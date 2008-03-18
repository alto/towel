class ExampleWorker < BackgrounDRb::MetaWorker
  set_worker_name :example_worker
  set_no_auto_load true

  def do_work(args)
    @logger.info('ExampleWorker work started')
    @logger.info("args = #{args}")
    user = User.find_by_login('alto')
    @logger.info("User found: #{user.login}, id=#{user.id}") if user
    @logger.info('ExampleWorker work finished')
  rescue Exception => exc
    @logger.error "ERROR: #{exc.message}"
  end
end

