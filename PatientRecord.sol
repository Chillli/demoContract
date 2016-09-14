contract PatientRecord{
    
    struct patient{
        address owner;
        address issuer;
        uint id;
        byte gender;
        uint age;
        string info;
        mapping(address => bool) trustees;
    }
    
    mapping (address => patient) patients;
    uint numPatient;

    address[] issuers;
    uint numIssuer;
    
    function PatientRecord(){
        numPatient = 0;
        issuers.push(tx.origin);
        numIssuer = 1;
    }
    
    function isIssuer(address adr) constant returns (bool){
        for (uint i = 0; i < numIssuer; i++) {
            if (issuers[i] == adr) return true;
            else return false;
        }
    }
    
    function issuePatient (address _owner, uint _id) {
        if (!isIssuer(tx.origin)) throw;
        patients[_owner].owner = _owner;
        patients[_owner].id = _id;
        patients[_owner].issuer = tx.origin;
    }
    
    function setData (uint _age, string _info, byte _gender) {
        if (patients[tx.origin].owner != tx.origin) throw;
        patients[tx.origin].age = _age;
        patients[tx.origin].info = _info;
        patients[tx.origin].gender = _gender;
    }
    
    function newIssuer (address _issuer) {
        if (tx.origin != issuers[0]) throw;
        issuers.push(_issuer);
        numIssuer++;
    }
    
    function checkIdentity (address _patient, uint _id) constant returns (bool){
        if (patients[_patient].id != _id) return false;
        return true;
    }
    
    function proveIdentity () returns(uint){
        return (patients[tx.origin].id);
    }
    
    function setTrustee (address _trustee){
        patients[tx.origin].trustees[_trustee] = true;
    }

    function checkTrustee (address _patient, address _trustee) constant returns (bool){
        return patients[_patient].trustees[_trustee];
    }
}
