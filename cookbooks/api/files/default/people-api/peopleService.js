const person = require('./sequelize');

/**
 * Gets person list.
 */
const getPeople = async () => {
    return new Promise((resolve, reject) => {
        person.findAll({
            raw: true
        })
            .then(data => {
                resolve(data);
            })
            .catch(err => {
                console.log(`Error getting people from DB.`);
                resolve(null);
            });
    })
}

/**
 * Gets person by national Id.
 * @param {string} nationalId National Id.
 */
const getPerson = async (nationalId) => {
    return new Promise((resolve, reject) => {
        person.findOne({
            raw: true,
            where: {
                national_id: nationalId
            }
        })
            .then(data => {
                resolve(data);
            })
            .catch(err => {
                console.log(`Error getting from DB person with national Id. ${nationalId}`);
                resolve(null);
            });
    })
}

/**
 * Creates person.
 * @param {JSON} personToSave 
 */
const savePerson = async (personToSave) => {
    return new Promise((resolve, reject) => {
        if (personToSave.nationalId == null)
            return resolve(null);

        person.create(personToSave)
            .then(personSaved => {
                console.log(`Saved: ${JSON.stringify(personSaved)}`);
                resolve(personSaved);
            })
            .catch(err => {
                console.log(`Error saving person in DB.`);
                resolve(null);
            });
    })
}

/**
 * Updates person fields (excepting national Id.)
 * @param {String} nationalId 
 * @param {JSON} fields 
 */
const updatePerson = async (nationalId, fields) => {
    return new Promise((resolve, reject) => {
        delete fields.nationalId; // Prevent update a primary value.

        person.update(fields, {
            where: {
                national_id: nationalId
            }
        })
        .then(personUpdated => {
                if (personUpdated[0] == 0) {
                    console.log(`Couldn't update person.`);
                    return resolve(false);
                }

                resolve(true);
            })
            .catch(e => {
                console.log(`Error when try to update person.: ${e.stack}`);
                resolve(null);
            })
    })
}

/**
 * Deletes person by national Id.
 * @param {String} nationalId 
 */
const deletePerson = async (nationalId) => {
    return new Promise((resolve, reject) => {
        person.destroy({
            raw: true,
            where: {
                national_id: nationalId
            }
        })
            .then(deleted => {
                resolve(deleted == 1);
            })
            .catch(err => {
                console.log(`Error deleting from DB person with national Id. ${nationalId}`);
                resolve(false);
            });
    })
}

module.exports = {
    getPeople,
    getPerson, 
    savePerson,
    updatePerson,
    deletePerson
};