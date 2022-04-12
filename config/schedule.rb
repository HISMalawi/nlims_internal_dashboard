every 1.day, at: ['7:30 am', '8:30 am', '9:30 am', '11:45 am', '2:30 pm', '6:00 pm', '8:00 pm'] do
    rake 'check_status:sync_status'
end
