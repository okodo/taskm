shared_examples_for 'tasks_events' do |_|
  it 'start task' do
    visit admin_tasks_path
    hide_navbar
    within(".states-events-gr.btn-group[data-tid='#{tasks.first.id}']") do
      first('button.btn.btn-sm.dropdown-toggle').click
      first("a[data-event='start']").click
    end
    expect(page).to have_css('button.btn.btn-sm.dropdown-toggle.btn-warning', visible: true, count: 1)
  end

  it 'finish task' do
    tasks.first.start!
    visit admin_tasks_path
    hide_navbar
    within(".states-events-gr.btn-group[data-tid='#{tasks.first.id}']") do
      first('button.btn.btn-sm.dropdown-toggle').click
      first("a[data-event='finish']").click
    end
    expect(page).to have_css('button.btn.btn-sm.dropdown-toggle.btn-danger', visible: true, count: 1)
  end

  it 'reopen task after start' do
    tasks.first.start!
    visit admin_tasks_path
    hide_navbar
    within(".states-events-gr.btn-group[data-tid='#{tasks.first.id}']") do
      first('button.btn.btn-sm.dropdown-toggle').click
      first("a[data-event='reopen']").click
    end
    expect(page).to have_css('button.btn.btn-sm.dropdown-toggle.btn-success', visible: true, count: 5)
  end

  it 'reopen task after finish' do
    tasks.first.start!
    tasks.first.finish!
    visit admin_tasks_path
    hide_navbar
    within(".states-events-gr.btn-group[data-tid='#{tasks.first.id}']") do
      first('button.btn.btn-sm.dropdown-toggle').click
      first("a[data-event='reopen']").click
    end
    expect(page).to have_css('button.btn.btn-sm.dropdown-toggle.btn-success', visible: true, count: 5)
  end

  it 'delete' do
    visit admin_tasks_path
    hide_navbar
    first("a.destroy-entry[data-tid='#{tasks.first.id}']").click
    expect(page).to have_css('table.table.table-striped tbody tr', visible: true, count: 4)
  end
end
