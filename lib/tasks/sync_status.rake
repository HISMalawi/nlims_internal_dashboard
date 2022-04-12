require 'sync_service'
namespace 'check_status' do
    task :sync_status => :environment do
        SyncService.check_sync_status
    end
end