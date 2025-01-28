// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ToDoList {
    struct Task {
        string content;
        bool completed;
    }

    mapping(address => Task[]) public tasks;

    // Event to emit when a new task is added
    event TaskAdded(address indexed user, uint256 taskId, string content);

    // Event to emit when a task is marked as completed
    event TaskCompleted(address indexed user, uint256 taskId);

    // Function to add a new task and return the task ID
    function addTask(string memory _content) public returns (uint256) {
        tasks[msg.sender].push(Task({
            content: _content,
            completed: false
        }));
        uint256 taskId = tasks[msg.sender].length - 1;
        emit TaskAdded(msg.sender, taskId, _content);
        return taskId; // Return the task ID
    }

    // Function to mark a task as completed
    function markTaskCompleted(uint256 _taskId) public {
        require(_taskId < tasks[msg.sender].length, "Task does not exist");
        tasks[msg.sender][_taskId].completed = true;
        emit TaskCompleted(msg.sender, _taskId);
    }

    // Function to get the number of tasks for the caller
    function getTaskCount() public view returns (uint256) {
        return tasks[msg.sender].length;
    }

    // Function to get a specific task
    function getTask(uint256 _taskId) public view returns (string memory content, bool completed) {
        require(_taskId < tasks[msg.sender].length, "Task does not exist");
        Task memory task = tasks[msg.sender][_taskId];
        return (task.content, task.completed);
    }

    // Function to get all tasks for the caller with task IDs
    function getAllTasks() public view returns (uint256[] memory, string[] memory, bool[] memory) {
        uint256 taskCount = tasks[msg.sender].length;
        uint256[] memory taskIds = new uint256[](taskCount);
        string[] memory contents = new string[](taskCount);
        bool[] memory completedStatuses = new bool[](taskCount);

        for (uint256 i = 0; i < taskCount; i++) {
            taskIds[i] = i; // Task ID is the index
            contents[i] = tasks[msg.sender][i].content;
            completedStatuses[i] = tasks[msg.sender][i].completed;
        }

        return (taskIds, contents, completedStatuses);
    }
}