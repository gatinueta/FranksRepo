import sys
import csv
import re

# python csv2plant.py d:\source\git\duplex-docs\CBT\tagesverarbeitung.csv  > tagesverarbeitung.puml
 
#03.07.2018 00:03;483392;SETA;OPENED;DAY;6701;20180703;;;;Tag eröffnet auf Server

# select d.*, p.description from (
#     select status_date, seq_no, process, status, 'DAY' unit, pst_nr, datum, null ws_nr, null uow_id, null doc_id
#     from zv_day_status_log
#     union
#     select u.status_date, seq_no, u.process, u.status, 'UOW', pst_nr, datum, ws_nr, uow_id, null doc_id
#     from zv_uow_status_log u
#     union
#     select status_date, seq_no, process, status, 'TX', pst_nr, datum, ws_nr, uow_id, doc_id
#     from zv_tx_status_log
#     WHERE doc_id <= 2
# ) d
# JOIN zvprocessing p
# ON d.process LIKE p.process AND d.status = p.status AND p.unit = d.unit
# where pst_nr = :pstNr and datum = :date

FIELDNAMES = ['timestamp', 'seq_no', 'process', 'status', 'unit', 'pst_nr', 'datum', 'ws_nr', 'uow_id', 'doc_id', 'description']
lane = { 'TX': -1, 'UOW': 0, 'DAY': 1, 'DAY / UOW / TX' : 0 }

#def statediagram(): 
#    uml = '''
#    @startuml
#
#    [*] --> State1
#    State1 --> [*]
#    State1 : this is a string
#    State1 : this is another string
#
#    State1 -> State2
#    State2 --> [*]
#
#    @enduml
#    '''
#
#    
#    arrows = { -2 : '-doubleleft->', -1 : '-left->', 0 : '-down->', 1: '-right->', 2: '-doubleright->' }
#
#    print('@startuml')
#
#    states = []
#    desc = []
#    names = []
#    lanes = []
#    with open(sys.argv[1], 'r') as csvfile:
#        reader = csv.DictReader(csvfile, delimiter=';', fieldnames=FIELDNAMES)
#        for row in reader:
#            print(row)
#            col = row[2];
#            name = '.'.join(row[0:3])
#            id = re.sub('\W+', '_', name)
#            states.append(id)
#            names.append(name)
#            desc.append(row[3]);
#            lanes.append(lane[row[2]])
#            
#    for i in range(1, len(states)):
#        arrow = arrows[lanes[i]-lanes[i-1]]
#        print ('{} {} {}'.format(states[i-1], arrow, states[i]))
#        print ('{} : {}'.format(states[i-1], desc[i-1]))
#        print ('state "{}" as {}'.format(names[i-1], states[i-1]))
#    print('@enduml')
#
def activitydiagram():
    uml = '''
    @startuml
    |Swimlane1|
    start
    :foo1;
    |#AntiqueWhite|Swimlane2|
    :foo2;
    :foo3;
    |Swimlane1|
    :foo4;
    |Swimlane2|
    :foo5;
    stop
    @enduml
        '''
    print("@startuml")

    with open(sys.argv[1], 'r') as csvfile:
        reader = csv.DictReader(csvfile, delimiter=';', fieldnames=FIELDNAMES)
        for row in reader:
            # print(row)
            swimlane = row['unit']
            if swimlane in lane:
                name = '{}.{}'.format(row['process'], row['status']) 
                
                id = '{} - {}'.format(row.get('uow_id'), row.get('doc_id'))
                
                print("|{}|".format(swimlane))
                print (":{};".format(name))
                print("note right")
                print("  " + row['description'])
                if row.get('uow_id') != '':
                    print("  ====")
                    id = "ws_nr=" + row['ws_nr'] + ",uow_id=" + row['uow_id']
                    if row.get('doc_id') != '':
                        id += ", doc_id=" + row['doc_id']
                    print("   " + id)
                print("end note")

    print('@enduml')

activitydiagram()