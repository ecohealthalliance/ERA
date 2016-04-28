run_orig:
	FLIRT_MONGO_URL=mongodb://flirt.eha.io:27017/grits-net-meteor \
FLIRT_MONGO_OPLOG_URL=mongodb://flirt.eha.io:27017/local \
BIRT_MONGO_URL=mongodb://birt.eha.io:27017/birt \
BIRT_MONGO_OPLOG_URL=mongodb://birt.eha.io:27017/local \
npm start

run:
	FLIRT_MONGO_URL=mongodb://localhost:3401/meteor \
FLIRT_MONGO_OPLOG_URL=mongodb://localhost:3401/local \
BIRT_MONGO_URL=mongodb://localhost:3401/meteor \
BIRT_MONGO_OPLOG_URL=mongodb://localhost:3401/local \
npm start
