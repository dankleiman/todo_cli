#!/usr/bin/env ruby

TODO_FILE = 'todo.txt'

def read_todo(line)
  line.chomp.split(/,/)
end

def write_todo(file, name, created_at = Time.now, completed = '')
  file.puts("#{name}, #{created_at}, #{completed}")
end

command = ARGV.shift

case command
when 'new'
  new_task = ARGV.shift
  File.open(TODO_FILE, 'a') do |file|
    write_todo(file, new_task)
    puts 'Task added'
  end
when 'list'
  counter = 1
  File.open(TODO_FILE, 'r') do |file|
    file.readlines.each do |line|
      name, created_at, completed = read_todo(line)
      puts("#{counter} - #{name}")
      puts("\t Created at #{created_at}")
      if completed.length > 2
        puts("\t Completed at #{completed}")
      end
      counter += 1
    end
  end
when 'done'
  task_number = ARGV.shift.to_i
  File.open(TODO_FILE, 'r') do |file|
    File.open("#{TODO_FILE}.new", 'w') do |new_file|
      counter = 1
      file.readlines.each do |line|
        name, created_at, completed = read_todo(line)
        if task_number == counter
          write_todo(new_file, name, created_at, Time.now)
          puts("Task #{counter} completed")
        else
          write_todo(new_file, name, created_at, completed)
        end
        counter += 1
      end
    end
  end
  `mv "#{TODO_FILE}.new" "#{TODO_FILE}"`
when 'remove'
  task_number = ARGV.shift.to_i
  File.open(TODO_FILE, 'r') do |file|
    File.open("#{TODO_FILE}.new", 'w') do |new_file|
      counter = 1
      file.readlines.each do |line|
        name, created_at, completed = read_todo(line)
        if task_number == counter
          puts("Task #{counter} removed")
        else
          write_todo(new_file, name, created_at, completed)
        end
        counter += 1
      end
    end
  end
  `mv "#{TODO_FILE}.new" "#{TODO_FILE}"`
else
  puts 'Unrecognized command'
end
