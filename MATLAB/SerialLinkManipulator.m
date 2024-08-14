classdef SerialLinkManipulator < handle
    %UNTITLED5 Summary of this class goes here
    %   Detailed explanation goes here

    properties
        dhparams
        nJoints
        links
        joints
        test
    end

    methods
        function robot = SerialLinkManipulator(dhtable, linkInfo)
            %UNTITLED5 Construct an instance of this class
            %   Detailed explanation goes here
            robot.nJoints = numrows(dhtable);
            robot.links = linkInfo;
            robot.joints = cell(robot.nJoints, 1);
        end
        
    end
end