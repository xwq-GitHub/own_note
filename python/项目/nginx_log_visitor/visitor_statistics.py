import plotly as py
import plotly.graph_objs as go

import mysql.connector
import pandas as pd

def visitor_statistics(dbuser,dbpassword,dbhost,dbbame,dbdate,serverid,outfilename):
    conn = mysql.connector.connect(user=dbuser, password=dbpassword, host=dbhost, database=dbbame)
    cursor = conn.cursor()
    cursor.execute('select * from visitor where nginxdate = %s and serverid = %s;', (dbdate,serverid))
    rows = cursor.fetchall()
    str(rows)[0:300]
    cursor.close()
    df = pd.DataFrame( [[ij for ij in i] for i in rows] )
    df.rename(columns={0: 'servername',1: 'nginxdate', 2: 'nginxtime', 3: 'hits', 4: 'visitors', 5:'bandwidth', 6:'avgts'}, inplace=True);
    df = df.sort_values(['nginxtime']);

    trace1 = go.Scatter(
        x=df['nginxtime'],
        y=df['hits'],
        mode = 'markers+lines',
    )

    layout = go.Layout(
        title=dbdate,
        xaxis=dict( title='nginxtime' ),
        yaxis=dict( title='hits' )
        )

    data = [trace1]
    fig = go.Figure(data=data, layout=layout)
    py.offline.plot(fig, filename=outfilename)

    return

def day_visitor_statistics(dbuser,dbpassword,dbhost,dbbame,dbdate,serverid,outfilename):
    conn = mysql.connector.connect(user=dbuser, password=dbpassword, host=dbhost, database=dbbame)
    cursor = conn.cursor()
    cursor.execute('select * from visitor where nginxdate = %s and serverid = %s;', (dbdate,serverid))
    rows = cursor.fetchall()
    str(rows)[0:300]
    cursor.close()
    df = pd.DataFrame( [[ij for ij in i] for i in rows] )
    df.rename(columns={0: 'serverid',1: 'nginxdate', 2: 'nginxtime', 3: 'hits', 4: 'visitors', 5:'bandwidth', 6:'avgts'}, inplace=True);
    df = df.sort_values(['nginxtime']);

    trace1 = go.Scatter(
        x=df['nginxtime'],
        y=df['visitors'],
        mode = 'markers+lines',
    )

    layout = go.Layout(
        title='hits of the_day',
        xaxis=dict( title='nginxtime' ),
        yaxis=dict( title='hits' )
        )

    data = [trace1]
    fig = go.Figure(data=data, layout=layout)
    py.offline.plot(fig, filename=outfilename)

    return
