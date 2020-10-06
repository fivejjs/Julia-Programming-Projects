module Database

using MySQL

const HOST = "localhost"
const USER = "root"
const PASS = "root"
const DB = "six_degrees"

CONN = DBInterface.connect(MySQL.Connection, HOST, USER, PASS, db=DB)

# const CONN = MySQL.connect(HOST, USER, PASS, db = DB)

export CONN

# disconnect() = MySQL.disconnect(CONN)
disconnect() = DBInterface.close!(CONN)
atexit(disconnect)

end
