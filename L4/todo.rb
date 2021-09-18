require "active_record"

class Todo < ActiveRecord::Base
  def due_today?
    due_date == Date.today
  end

  def to_displayable_string
    index = id
    display_status = completed ? "[X]" : "[ ]"
    display_date = due_today? ? nil : due_date
    "#{index}. #{display_status} #{todo_text} #{display_date}"
  end

  def self.overdue
    all.filter { |todo| todo.due_date < Date.today }
  end

  def self.due_today
    all.filter { |todo| todo.due_date == Date.today }
  end

  def self.due_later
    all.filter { |todo| todo.due_date > Date.today }
  end

  def self.to_displayable_list
    all.map { |todo| todo.to_displayable_string }
  end

  def self.add_task(h)
    Todo.create!(todo_text: h[:todo_text], due_date: Date.today + h[:due_in_days], completed: false)
  end

  def self.mark_as_complete(id)
    user = self.find_by(id: id)
    user.completed = true
    user.save
    user
  end

  def self.show_list
    puts "My Todo-list\n\n"

    puts "Overdue\n"
    puts self.overdue.map { |todo| todo.to_displayable_string }
    puts "\n"

    puts "Due Today\n"
    puts self.due_today.map { |todo| todo.to_displayable_string }
    puts "\n\n"

    puts "Due Later\n"
    puts self.due_later.map { |todo| todo.to_displayable_string }
    # puts "\n\n"
  end
end
