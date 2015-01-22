CREATE GRAIN workflow VERSION '1.0';

-- *** TABLES ***

CREATE TABLe processes(
	processKey varchar(30) NOT NULL,
	processName varchar(100) NOT NULL,
	CONSTRAINT pk_processes PRIMARY KEY (processKey)
);

CREATE TABLE form(
  processKey varchar(30) NOT NULL,
  id varchar(30) NOT NULL,
  /**скрипт для открывания*/
  sOpen TEXT,
  /**скрипт для сохранения*/
  sSave TEXT,
  /**скрипт для действия*/
  sAction TEXT,
  link TEXT,
  isStartForm BIT NOT NULL DEFAULT 0,
  CONSTRAINT Pk_forms PRIMARY KEY (processKey,id)
);

CREATE TABLE processStatusModel(
	processKey varchar(30) NOT NULL,
	modelId varchar(50) NOT NULL,
	CONSTRAINT pk_processStatusModel PRIMARY KEY (processKey)
);


CREATE TABLE matchingCircuit(
	processKey varchar(30) NOT NULL,
	taskKey varchar(30) NULL,
	id int NOT NULL,
	name varchar(50) NOT NULL,
	type varchar(50) NOT NULL,
	assJSON TEXT,
	number varchar(30) NOT NULL,
	sort varchar(100) NOT NULL,
	CONSTRAINT pk_matchingCircuit PRIMARY KEY(processKey,id)
);

CREATE TABLE status(
  id VARCHAR(50) NOT NULL,
  name VARCHAR(100) NOT NULL,
  modelId VARCHAR(50) NOT NULL,
  varName varchar(50),
  CONSTRAINT Pk_statuses PRIMARY KEY (id, modelId)
);

CREATE TABLE statusModel(
  id VARCHAR(50) NOT NULL,
  name VARCHAR(100) NOT NULL,
  CONSTRAINT Pk_statusModel PRIMARY KEY (id)
);

CREATE TABLE statusTransition(
  name VARCHAR(100) NOT NULL,
  statusFrom VARCHAR(50) NOT NULL,
  modelFrom VARCHAR(50) NOT NULL,
  statusTo VARCHAR(50) NOT NULL,
  modelTo VARCHAR(50) NOT NULL,
  CONSTRAINT PK_statusTransition PRIMARY KEY (statusFrom, modelFrom, statusTo, modelTo)
);

CREATE TABLE userGroup(
	userId VARCHAR(36) NOT NULL,
	groupId VARCHAR(36) NOT NULL,
	CONSTRAINT PK_userGroup PRIMARY KEY (userId, groupId)
);

CREATE TABLE groups(
	groupId VARCHAR(36) NOT NULL,
	groupName VARCHAR(100) NOT NULL,
	number VARCHAR(30) NOT NULL,
	sort VARCHAR(100) NOT NULL,
	CONSTRAINT PK_group PRIMARY KEY(groupId)
);



-- *** FOREIGN KEYS ***
ALTER TABLE userGroup ADD CONSTRAINT fk_users_groups FOREIGN KEY (groupId) REFERENCES workflow.groups(groupId);
ALTER TABLE status ADD CONSTRAINT fk_status FOREIGN KEY (modelId) REFERENCES workflow.statusModel(id);
ALTER TABLE matchingCircuit ADD CONSTRAINT fk_procKey FOREIGN KEY (processKey) REFERENCES workflow.processes(processKey);
ALTER TABLE statusTransition ADD CONSTRAINT fk_statustransition_status FOREIGN KEY (statusFrom, modelFrom) REFERENCES workflow.status(id, modelId);
ALTER TABLE statusTransition ADD CONSTRAINT fk_statustransition_status2 FOREIGN KEY (statusTo, modelTo) REFERENCES workflow.status(id, modelId);
ALTER TABLE processStatusModel ADD CONSTRAINT fk_procStatModel FOREIGN KEY (modelId) REFERENCES workflow.statusModel(id);
-- *** INDICES ***
CREATE INDEX idx_statusTransition ON statusTransition(statusFrom, modelFrom);
CREATE INDEX idx_statusTransition_0 ON statusTransition(statusTo, modelTo);
-- *** VIEWS ***
