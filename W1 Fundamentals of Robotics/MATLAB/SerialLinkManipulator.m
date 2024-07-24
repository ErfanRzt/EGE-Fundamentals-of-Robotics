classdef SerialLinkManipulator
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here

    properties
        nJoints
        nLinks
        linksLength
        initialState
    end

    methods
        function obj = SerialLinkManipulator(links, initialState)
            %UNTITLED Construct an instance of this class
            %   Detailed explanation goes here
            obj.nLinks = numel(links);
            obj.linksLength = links;
            obj.nJoints = numel(initialState);
            obj.initialState = initialState;
        end

        function joints = taskSpace(obj, configuration, draw)
            if nargin < 3
                draw = false;
            end

            jointsPloar = [configuration, obj.linksLength];
            joints = zeros([obj.nJoints + 1, 2]);

            cumulativeAngle = 0;

            for i = 1:obj.nJoints
                cumulativeAngle = cumulativeAngle + jointsPloar(i, 1);
                [x_offset, y_offset] = pol2cart(cumulativeAngle, jointsPloar(i, 2));
            
                joints(i+1, 1) = joints(i, 1) + x_offset;
                joints(i+1, 2) = joints(i, 2) + y_offset;
            end

            if draw
                figure;
                plot(   joints(:, 1), joints(:, 2), ...
                        "LineWidth", 5, "LineStyle", '-', "Color", 'g'  );
                hold on;
                plot(   joints(1:obj.nJoints, 1), joints(1:obj.nJoints, 2), ...
                        'or', "LineWidth", 2);
                hold on;
                plot(   joints(1:obj.nJoints, 1), joints(1:obj.nJoints, 2), ...
                        '.r', "LineWidth", 2);
                hold on;
                plot(   joints(end, 1), joints(end, 2), ...
                        '+r', "LineWidth", 2);
                axis equal; grid on; axis (draw*[-1 1 -1 1]);
            end
        end

        function anim = drawConfiguration(obj, configuration)
            figure;
            for i = configuration
                joints = obj.taskSpace(i, false);
            
                plot1 = plot(   joints(:, 1), joints(:, 2), ...
                        "LineWidth", 5, "LineStyle", '-', "Color", 'g'  );
                hold on;
                plot2 = plot(   joints(1:obj.nJoints, 1), joints(1:obj.nJoints, 2), ...
                        'or', "LineWidth", 2);
                hold on;
                plot3 = plot(   joints(1:obj.nJoints, 1), joints(1:obj.nJoints, 2), ...
                        '.r', "LineWidth", 2);
                hold on;
                plot4 = plot(   joints(end, 1), joints(end, 2), ...
                        '+r', "LineWidth", 2);
                axis equal; grid on; axis (20*[-1 1 -1 1]);
            
                plots = [plot1 plot2 plot3 plot4];
                pause(0.01);
                delete(plots);
            end
        end

%         %MONITORING Tools for making figures and online simulation
%         function linkRect = initLink(obj, x1, x2, y1, y2)
%             %METHOD1 Summary of this method goes here
%             %   Detailed explanation goes here
%             linkRect.vertices = [   x1  y1  ; ...
%                                     x2  y1  ; ...
%                                     x2  y2  ; ...
%                                     x1  y2  ];
% 
%             linkRect.faces = [  1   2   3   ; ...
%                                 1   3   4   ];
%         end
% 
%         function serialLinksRect = appendLinks(obj, links, newLink)
%             %METHOD2 Summary of this method goes here
%             %   Detailed explanation goes here
%             nPrevs = size(links.vertices, 1);
%             
%             serialLinksRect.vertices = [links.vertices; newLink.vertices];
%             serialLinksRect.faces = [links.faces; newLink.faces + nPrevs];
%         end
% 
%         function tf = transformLinks(obj, link, rotation, translation)
%             %METHOD3 Summary of this method goes here
%             %   Detailed explanation goes here
%             tf.faces = link.faces;
%             
%             c = cosd(rotation);
%             s = sind(rotation);
%             
%             tf.vertices = link.vertices * [c s; -s c] + translation;
%         end
% 
%         function links = serialLinkPoly(obj, configuration)
%             %METHOD4 Summary of this method goes here
%             %   Detailed explanation goes here
%             h = min(obj.linksLength) / 20;
% 
%             a = obj.initLink(0, obj.linksLength(1), -h, h);
%             links = a;
%             
%             for i = 1:(obj.nLinks-1)
%                 links = obj.appendLinks(a, obj.transformLinks(links, configuration(i), [ obj.linksLength(i), 0]));
%             end
%             
%             links = obj.transformLinks(links, configuration(end), [0 0]);
%         end
    end
end