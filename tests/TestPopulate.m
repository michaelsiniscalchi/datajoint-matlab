classdef TestPopulate < Prep
    methods(Test)
        function testPopulate(testCase)
            st = dbstack;
            disp(['---------------' st(1).name '---------------']);
            package = 'Lab';
            
            c1 = dj.conn(...
                testCase.CONN_INFO.host,... 
                testCase.CONN_INFO.user,...
                testCase.CONN_INFO.password,'',true);

            dj.createSchema(package,[testCase.test_root '/test_schemas'], ...
                [testCase.PREFIX '_lab']);

            insert(Lab.Subject, {
               0, '2020-04-02';
            });

            insert(Lab.Rig, struct( ...
                'rig_manufacturer', 'FooLab', ...
                'rig_model', '1.0', ...
                'rig_note', 'FooLab Frobnicator v1.0' ...
            ));

            % regular populate of 1 record
            % .. (SessionAnalysis logs session ID as session_analysis data)

            insert(Lab.Session, struct( ...
                'session_id', 0, ...
                'subject_id', 0, ...
                'rig_manufacturer', 'FooLab', ...
                'rig_model', '1.0' ...
            ));

            populate(Lab.SessionAnalysis);
            a_result = fetch(Lab.SessionAnalysis & 'session_id = 0', '*');
            testCase.verifyEqual(a_result.session_analysis, 0);

            % parallel populate of 1 record
            % .. (SessionAnalysis logs jobs record as session_analysis data)

            insert(Lab.Session, struct( ...
                'session_id', 1, ...
                'subject_id', 0, ...
                'rig_manufacturer', 'FooLab', ...
                'rig_model', '1.0' ...
            ));

            parpopulate(Lab.SessionAnalysis);
            a_result = fetch(Lab.SessionAnalysis & 'session_id = 1', '*');
            testCase.verifyEqual(a_result.session_analysis.connection_id, c1.serverId);

        end
    end
end
