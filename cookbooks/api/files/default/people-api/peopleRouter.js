const express = require('express');
const peopleService = require('./peopleService');
const router = express.Router();
const {default: validateContentType} = require('@natlibfi/express-validate-content-type');

/**
 * Get person list.
 */
router.get('/people/', async (req, res, next) => {
    const people = await peopleService.getPeople();

    if (people == null) {
        return res.status(404).json();
    }
    
    res.status(200).json(people);
});

/**
 * Gets a person by national Id.
 */
router.get('/people/:nationalId/', async (req, res, next) => {
    const personFound = await peopleService.getPerson(req.params.nationalId);
    
    if (personFound == null) {
        return res.status(404).json();
    }
    
    res.status(200).json(personFound);
});

/**
 * Creates a person.
 */
router.post('/people/', validateContentType({type: 'application/json'}), async (req, res, next) => {
    const person = req.body;

    const personSaved = await peopleService.savePerson(person);

    if (personSaved == null) {
        return res.status(500).json();
    }
    
    res.status(201).json(personSaved);
});

/**
 * Updates person fields by national Id.
 */
router.put('/people/:id/', validateContentType({type: 'application/json'}), async (req, res, next) => {
    const fieldsToUpdate = req.body;
    
    const updated = await peopleService.updatePerson(req.params.id, fieldsToUpdate);

    if (updated == null)
        return res.status(500).json();

    if (!updated)
        return res.status(404).json();

    res.status(200).json();
});

/**
 * Deletes person by national Id.
 */
router.delete('/people/:id/', async (req, res, next) => {
    const deleted = await peopleService.deletePerson(req.params.id);

    if (!deleted)
        return res.status(404).json();
    
    res.status(200).json();
});

module.exports = router;