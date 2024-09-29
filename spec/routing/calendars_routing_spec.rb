require 'rails_helper'

RSpec.describe CalendarController, type: :routing do
  describe 'routing' do
    # Test the route for /calendars
    it 'routes to #calendars' do
      expect(get: '/calendars').to route_to('calendar#calendars')
    end

    # Test the route for /events/:calendar_id (GET)
    it 'routes to #events with calendar_id' do
      expect(get: '/events/123').to route_to('calendar#events', calendar_id: '123')
    end

    # Test the route for /events/:calendar_id (POST)
    it 'routes to #new_event with calendar_id' do
      expect(post: '/events/123').to route_to('calendar#new_event', calendar_id: '123')
    end

    # Ensure the regex constraint is working for calendar_id
    it 'routes to #events with complex calendar_id' do
      expect(get: '/events/my-calendar-123').to route_to('calendar#events', calendar_id: 'my-calendar-123')
    end

    it 'routes to #new_event with complex calendar_id' do
      expect(post: '/events/my-calendar-123').to route_to('calendar#new_event', calendar_id: 'my-calendar-123')
    end
  end
end
