classdef PreconditionerFactory < handle
%PRECONDITIONERFACTORY
%   This file is part of redbKIT.
%   Copyright (c) 2016, Ecole Polytechnique Federale de Lausanne (EPFL)
%   Author: Federico Negri <federico.negri at epfl.ch>

    properties (GetAccess = private)
        M_dictionnary = containers.Map(); % Hash table
    end
    
    methods
        
        %% Constructor
        function factory = PreconditionerFactory()
            
            factory = factory@handle();
            
            % Pre-register some well-known precon
            factory.RegisterPrecon('None', @(x) Preconditioner(x));
            factory.RegisterPrecon('ILU', @(x) ILU_Preconditioner(x));
            factory.RegisterPrecon('AdditiveSchwarz', @(x) AS_Preconditioner(x));
            
        end
        
        function [] = RegisterPrecon(factory, preconName, createPreconCallback)
            % Adds new sensor to the factory
            factory.M_dictionnary(preconName) = createPreconCallback;
        end
        
        function [preconList] = GetListOfPrecon(factory)
            % Obtains the list of available sensors
            preconList = factory.M_dictionnary.keys;
        end
        function [precon] = CreatePrecon(factory, preconName, varargin)
            % Creates sensor instance
            createCallback = factory.M_dictionnary(preconName);
            precon = createCallback(varargin{:});
        end
        
    end
    
end