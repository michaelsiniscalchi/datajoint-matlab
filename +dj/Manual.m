classdef Manual < dj.internal.UserRelation
% Defines a manual table
    properties(Constant)
        tierRegexp = ['(?<manual>' ...
                      dj.Schema.tierPrefixes{strcmp(dj.Schema.allowedTiers, 'manual')} ...
                      dj.Schema.baseRegexp ')']
    end
    methods
        function self = Manual(varargin)
            self@dj.internal.UserRelation(varargin{:})
        end
    end
end